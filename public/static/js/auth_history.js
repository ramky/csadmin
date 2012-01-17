//  Search for Vindicia Authorizations for email.
//  table (html fragment) is returned, appended to search box.
var search = function(search_string){
    $('.tablesorter').empty().remove();

    $.ajax({ url:  'auth',
             dataType: 'html',
             type: 'post',
             data: {search_string: search_string}, 
             success: function(result_table){
                 if($('.result-row', result_table).length > 0){
                     $('#auth-form').append(result_table);

                     $('.tablesorter').tablesorter({
                         widthFixed: true,
                         widgets: ['zebra']
                     });


                     $(".result-row").click(function(){

                         $(this).find('input').attr('checked', 'checked');
                     });

                 }else{
                     alert("Search returned no results");
                 }
             }
           });
};


$(function(){
    $("#search-button").click(function(e){
        e.preventDefault();
        var search_string = $('input#search-string').val();
    
        search(search_string);
    });
});

