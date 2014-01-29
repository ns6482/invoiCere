jQuery ->
  subscription.setupForm()

subscription =
  
  setupForm: ->
    $('.update_sub').submit ->
      $('input[type=submit]').attr('disabled', true)
      if $('#card_number').length
        subscription.processCard()
        false
      else
        true
  
  
  
   tdsInit: (redirect, cancelCallback) ->
      iframe = document.getElementsByTagName("iframe")[0]
      if iframe
        iframe.parentNode.removeChild iframe
     
     

     
      url = redirect.url
      params = redirect.params
      body = document.getElementById('tdsecure-form')
      iframe = document.createElement("iframe")
      iframe.className = "col-md-6"
        
      link = document.createElement("link")
      link.setAttribute "href", "/assets/application.css?body=1"

  
        
     # link = document.createElement("link")
     # link.setAttribute "rel", "stylesheet"
     # link.setAttribute "type", "text/css"
     # link.setAttribute "href", "/assets/application.css?body=1"
     # iframe.getElementsByTagName("head")[0].appendChild link
        
        
      body.insertBefore iframe, body.firstChild
      iframeDoc = iframe.contentWindow or iframe.contentDocument
      iframeDoc = iframeDoc.document  if iframeDoc.document
      form = iframeDoc.createElement("form")
      form.method = "post"
      form.action = url
      for k of params
        input = iframeDoc.createElement("input")
        input.type = "hidden"
        input.name = k
        input.value = decodeURIComponent(params[k])
        form.appendChild input
      if iframeDoc.body
        iframeDoc.body.appendChild form
      else
        iframeDoc.appendChild form
          
          
      form.submit()
      $('#tdsecure-modal').modal('show')   
  

    tdsCleanup: ->
      $('#tdsecure-modal').modal('hide')   
      iframe = document.getElementsByTagName("iframe")[0]
      iframe.parentNode.removeChild iframe
      
     
    handlePaymillResponse: (error, result) ->
      if error
        $('#paymill_error').text(error.apierror)
        $('input[type=submit]').attr('disabled', false)
        
      else
        $('.paymill_card_token').val(result.token)
        $('.update_sub')[0].submit()
      
    processCard: ->
      
      
      card =
        amount_int: Math.round($('.amount').val() * 100)
        number: $('#card_number').val()
        cvc: $('#card_code').val()
        exp_month: $('#card_month').val()
        exp_year: $('#card_year').val()
        currency: $('.currency').val()

      paymill.createToken(card, subscription.handlePaymillResponse, subscription.tdsInit, subscription.tdsCleanup)
  
