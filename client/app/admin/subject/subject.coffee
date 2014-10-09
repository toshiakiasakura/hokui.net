'use strict'

angular.module appName
.config ($stateProvider) ->
    $stateProvider

    .state 'admin.subject',
        url: '/subject',
        views:
            'main@admin':
                templateUrl: '/app/admin/subject/subject.html'
                controller: 'AdminSubjectCtrl'
                resolve:
                    subjects: (Subject)->
                        Subject.query().$promise

            'main@admin.subject':
                templateUrl: '/app/admin/subject/list.html'
                controller: 'AdminSubjectListCtrl'

    .state 'admin.subject.detail',
        url: '/:id',
        views:
            'main@admin.subject':
                templateUrl: '/app/admin/subject/detail.html'
                controller: 'AdminSubjectDetailCtrl'

    .state 'admin.subject.detail.edit',
        url: '/edit',
        views:
            'edit@admin.subject.detail':
                templateUrl: '/app/admin/subject/edit.html'
                controller: 'AdminSubjectEditCtrl'


.controller 'AdminSubjectCtrl',
    ($scope, subjects, ResourceStore) ->
        $scope.subjects = ResourceStore subjects


.controller 'AdminSubjectListCtrl',
    ($scope, Subject) ->


.controller 'AdminSubjectDetailCtrl',
    ($scope, Subject, $state, $stateParams, Notify) ->
        subject_id = $stateParams.id

        if subject_id isnt ''
            $scope.subject = $scope.subjects.retrieve subject_id
            if not $scope.subject?
                $state.go 'admin.subject'
                Notify "Not found subject(id: \"#{subject_id}\")", type: 'warning'


.controller 'AdminSubjectEditCtrl',
    ($scope, Subject, $state, $stateParams, Notify) ->
        $scope.editing = $scope.subject?.id?
        $scope.title = if $scope.editing then '編集' else '新規作成'

        $scope.deleting = false

        $scope.new_subject = new Subject()
        if $scope.editing
            angular.extend $scope.new_subject, $scope.subject

        $scope.doSaveSubject = ()->
            if $scope.editing
                $scope.new_subject.$update {}, (data)->
                    $scope.subjects.set data
                    $state.go 'admin.subject.detail', {id: data.id}
                    Notify '保存しました。'
            else
                $scope.new_subject.$save {}, (data)->
                    $scope.subjects.set data
                    $state.go 'admin.subject.detail', {id: data.id}
                    Notify '新規作成しました。'

        $scope.doDeleteSubject = ()->
            $scope.subject.$remove {}, (data)->
                $scope.subjects.del $scope.subject
                $state.go 'admin.subject'
                Notify '削除しました。', type: 'danger'

        $scope.deleteSubject = ()->
            console.log 'del'
            if $scope.deleting
                $scope.doDeleteSubject()
            else
                Notify 'もう一度クリックすると削除します。', type: 'danger'
                $scope.deleting = true

        $scope.stopDeleting = ->
            $scope.deleting = false
            Notify '削除を中断しました。', type: 'warning'

        $scope.deleteBtnLabel = ()->
            if $scope.deleting
                return "マジで削除する"
            else
                return '削除する'






