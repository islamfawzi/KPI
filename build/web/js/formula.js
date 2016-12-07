
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
app.controller('formulaCtrl', ['$scope', 'Func', function ($scope, Func) {

        $scope.json = Func.getJson();

        // define all functions categories to the DOM
        $scope.categorys = Func.getCats();

        $scope.category = "";
        $scope.function = "";
        $scope.field = "";
        $scope.formula = $('#old-formula').val() != undefined ? $('#old-formula').val() : "";
        $scope.operator = "0";

        /*
         * on change fields
         */
        $scope.addField = function () {

            $scope.formula = $scope.formula + "{" + $scope.field + "}";
            console.log($scope.formula);
        };

        /** 
         * on change Functions
         */
        $scope.addFunction = function () {

            $scope.formula = $scope.formula + $scope.function;
            console.log($scope.formula);
        };

        /**
         * on change operators
         */
        $scope.addOperator = function () {

            $scope.formula = $scope.formula + $scope.operator;
            console.log($scope.formula);
        };

        /**
         * on submit add-edit formula ( validation )
         */
        $scope.validate = function (e) {
            $(".form-control").removeClass("red-alert");
            $(".error").empty();

            var title = $("input[name=title]");
            var formula = $('textarea[name=formula]');

            // validate formula
            var valid = validate_formula(formula.val());

            if (title.val() == "") {
                title.addClass("red-alert");
                $("#title_error").text("Title Required");
                valid = false;
            }
            if (formula.val() == "") {
                formula.addClass("red-alert");
                $("#formula_error").text("Formula Required");
                valid = false;
            }


            if (!valid) {
                e.preventDefault();
            } else {
                console.log("valid");
            }
        };

        /**
         * validate formula
         */
        var validate_formula = function(formula) {
            $('textarea[name=formula]').removeClass("red-alert");
            var v = true;
            if (formula != "") {
                $.ajax({
                    method: "POST",
                    url: "ajax.jsp",
                    data: {formula: formula},
                    async: false
                }).done(function (v_msg) {

                    if (v_msg.indexOf("valid") <= -1) {
                        $('textarea[name=formula]').addClass("red-alert");
                        $("#formula_error").text(v_msg);
                        v = false;
                    }
                });
            } else {
                v = false;
            }
            return v;
        }

    }]);




