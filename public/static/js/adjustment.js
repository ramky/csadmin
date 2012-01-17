function adjustment_post(){
  cancel_checked = $("input:checked[name=cancel]").length;
  cancel_skus = ''
  if (cancel_checked > 0){
    $("input:checked[name=cancel]").each(function(){
      if (cancel_skus == ''){
        cancel_skus = this.value;
      }
      else{
        cancel_skus = cancel_skus + ',' + this.value;
      }
    });
  }

  upgrade_checked = $("input:checked[name=to_upgrade]").length;
  upgrade_skus = ''
  if (upgrade_checked > 0){
    $("input:checked[name=to_upgrade]").each(function(){
      if (upgrade_skus == ''){
        upgrade_skus = this.value;
      }
      else{
        upgrade_skus = upgrade_skus + ',' + this.value;
      }
    });
  }

  if (cancel_checked == 0 && upgrade_checked == 0 && $('#refund').attr('checked') == false){
    alert("Select a sku or upgrade or cancel or select \"Click to Refund\" for refunds.");
    return false;
  }
  
  if(cancel_checked > 0){
    $('#cancel_skus').val(cancel_skus);
  }
  if(upgrade_checked > 0){
    $('#upgrade_skus').val(upgrade_skus);
  }
   // If you've come this far, all ok return true
  return true;
}

function toggle_price(){
  if ($('#refund').attr('checked')) {
    $('#hidden-price').show();
  }
  else{
    $('#hidden-price').hide();
  }
}
