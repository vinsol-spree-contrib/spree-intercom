function SpreeIntercom(options) {
  this.$intercomApplicationId = options.$intercomApplicationId;
  this.$currentUserEmail = options.$currentUserEmail;
  this.$currentUserId = options.$currentUserId;
  this.$numberOfOrders = options.$numberOfOrders;
}

SpreeIntercom.prototype.initialize = function() {
  this.setIntercomSettings();
  this.runIntercom();
}

SpreeIntercom.prototype.setIntercomSettings = function () {
  var _this = this;

  if(this.$currentUserEmail.length) {
    window.intercomSettings = {
      app_id: _this.$intercomApplicationId.data('value'),
      email: _this.$currentUserEmail.data('value'),
      user_id: _this.$currentUserId.data('value'),
      number_of_orders: _this.$numberOfOrders.data('value')
    };
  } else {
    window.intercomSettings = {
      app_id: _this.$intercomApplicationId.data('value')
    };
  }
}

SpreeIntercom.prototype.runIntercom = function() {
  var APP_ID = this.$intercomApplicationId.data('value');

  var w=window;var ic=w.Intercom;if(typeof ic==="function")
  {ic('reattach_activator');ic('update',intercomSettings);}else
  {var d=document;var i=function(){i.c(arguments)};i.q=[];i.c=function(args)
  {i.q.push(args)};w.Intercom=i;function l()
  {var s=d.createElement('script');s.type='text/javascript';s.async=true;
  s.src='https://widget.intercom.io/widget/' + APP_ID;
  var x=d.getElementsByTagName('script')[0];
  x.parentNode.insertBefore(s,x);}if(w.attachEvent){w.attachEvent('onload',l);}
  else{w.addEventListener('load',l,false);}}
}

$(function() {
  var options = {
    $intercomApplicationId: $('[data-hook="intercom_application_id"]'),
    $currentUserEmail: $('[data-hook="current_user_email"]'),
    $currentUserId: $('[data-hook="current_user_id"]'),
    $numberOfOrders: $('[data-hook="completed_orders_count"]')
  },
  spreeIntercom = new SpreeIntercom(options);

  spreeIntercom.initialize();
})
