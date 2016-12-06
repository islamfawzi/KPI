
$.ajaxSetup({
    async: false
});

/**
 * 
 * App
 */
var app = angular.module('app', []);

/**
 * 
 * Service
 */
app.service("Func", function () {

    this.getJson = function () {

        var obj;

        $.getJSON("js/functions.json", function (json) {
            obj = json;
        });

        return obj;
    },
    this.getFunc = function (key) {

        return this.getJson()[key];
    },
    this.getCats = function () {

        return Object.keys(this.getJson());
    };
});

/**
 * 
 * Controller
 */
app.controller('Ctrl', ['$scope', 'Func', function ($scope, Func) {

        $scope.json = Func.getJson(); 
        
        // define all functions categories to the DOM
        $scope.categorys = Func.getCats();
    
        $scope.category = "";
        $scope.function = "";

}]);





