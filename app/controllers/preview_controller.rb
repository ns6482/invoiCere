class PreviewController < ApplicationController
  layout "dashboard"
  
   
  def show
    #if params[:id] 
      @invoice = Invoice.find_by_secret_id("xlBcFmZR0xmFRI-rJgYO6A")
    #end
  end
end