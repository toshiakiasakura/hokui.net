'use strict'

angular.module appName
.factory 'Auth',
    ($http, $rootScope, $q, Token) ->
        current:
            active: false
            user : {}

        login: (user) ->
            deferred = $q.defer()
            $http.post '/api/session',
                email: user.email
                password: user.password
            .success (data) =>
                Token.set(data.token)
                @current.active = true
                @current.user = data.user
                deferred.resolve @current
            .error (err) ->
                deferred.reject err

            deferred.promise

        logout: (callback) ->
            deferred = $q.defer()
            if Token.get()
                $http.delete '/api/session', {}
                .success (data) =>
                    @silentLogout()
                    deferred.resolve()

            else
                @silentLogout()
                deferred.resolve()

            deferred.promise

        silentLogout: ()->
            Token.clear()
            @current.active = false
            @current.user = {}


        check: (callback) ->
            deferred = $q.defer()
            if Token.get()
                $http.get '/api/users/profile', {}
                .success (data) =>
                    @current.active = true
                    @current.user = data
                    deferred.resolve @current
                .error (err) =>
                    deferred.reject @current

            else
                @silentLogout()
                deferred.reject @current

            deferred.promise

.run (Auth)->
    Auth.check()
