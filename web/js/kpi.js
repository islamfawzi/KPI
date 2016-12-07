var app = angular.module("app", []);

app.service("Kpi", ['$http', '$q', function ($http, $q) {

        this.getTableCols = function (table_name) {

            var q = $q.defer();
            $http({
                method: 'POST',
                url: 'ajax.jsp',
                data: {tablename: table_name},
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(function (data) {
                q.resolve(data);
            }).error(function (data) {
                q.reject("Error");
            });

            return q.promise;
        }
    }]);

app.controller("kpiCtrl", ["$scope", "$http", "Kpi", function ($scope, $http, Kpi) {

        $scope.table_id = "0";
        
        $scope.getSheetXaxis = function (table_name) {

            $scope.promise = Kpi.getTableCols(table_name);
            $scope.promise.then(
                    function (v) {
                        $scope.x_axis = v
                    },
                    function (err) {
                        console.log(err);
                    }
            );
        };

        var table_name = $('option:selected', "select[name=table_id]").attr('tablename') || "";
       
        $scope.x_axis = $scope.getSheetXaxis(table_name);

        $scope.onChangeSheet = function () {

            var table_id = parseInt($scope.table_id);

            if (table_id == 0) {
                $scope.x_axis = {};
            } else {
                var table_name = $('option:selected', "select[name=table_id]").attr('tablename');

                $scope.x_axis = this.getSheetXaxis(table_name);

            }
        };

    }]);

app.filter('isEmpty', function () {
    var bar;
    return function (obj) {
        for (bar in obj) {
            if (obj.hasOwnProperty(bar)) {
                return false;
            }
        }
        return true;
    };
});

