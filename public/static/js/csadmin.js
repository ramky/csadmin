

var Cs = function(){

    //  The user has chosen a particular sale to manipulate.
    //  Set this as the current sale on the backend.  
    //  Display this on the current page without having to do full reload.
    var set_order_info = function(order){
        $.ajax({ url:  'session/sale_info',
                 dataType: 'json',
                 type: 'post',
                 data: order,
                 success: function(o){
                     $("#current-sale-id"). text(o.sale_id);
                     $("#current-order-id").text(o.order_id);
                     $("#current-email").   text(o.email);
                 }
               });
    };
    

    return {
        //  Search for sale records by type: email, activation code, name, order number.
        //  table (html fragment) is returned, appended to search box.
        search: function(search_type, search_string){
            $('.tablesorter').empty().remove();

            $.ajax({ url:  'search',
                     dataType: 'html',
                     type: 'post',
                     data: {search_type:   search_type,
                            search_string: search_string}, 
                     success: function(result_table){
                         if($('.result-row', result_table).length == 0){
                             alert("Search returned no results");
                         }else{
                             $('#search-form').append(result_table);

                             $('.tablesorter').tablesorter({
                                 widthFixed: true,
                                 widgets: ['zebra']
                             });

                             $(".result-row.not-adjusted").click(function(e){
                                 $(this).find('input').attr('checked', 'checked');
                                 $.each($.data.orders, function(i, order){
                                     if(order.order_id === e.currentTarget.id){
                                         set_order_info(order);
                                         return false;
                                     }
                                 });
                             });

                             $(".result-row.adjusted").click(function(e){
                                 $(this).find('input').attr('checked', '');
                                 alert("The order you selected has been adjusted and "+
                                       "cannot be selected to perform an action.  Please " +
                                       "select an order that has not been adjusted.");
                             });
                         }
                     }
                   });
        }
    }
}();


$(function(){
    $("#search-button").click(function(e){
        e.preventDefault();
        var search_type   = $('input[type="radio"]:checked').val(),
            search_string = $('input#search-string').val();
    
        Cs.search(search_type, search_string);
    });
});

