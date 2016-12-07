$("#checkall").click(function () {
    var checkall = $(this).is(":checked");
    $("input[type=checkbox]").prop("checked", checkall);
});


