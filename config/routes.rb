Rails.application.routes.draw do
  # Routes for the Response resource:

  # CREATE
  post("/insert_response", { :controller => "responses", :action => "create" })
          
  # READ
  get("/responses", { :controller => "responses", :action => "index" })
  
  get("/responses/:path_id", { :controller => "responses", :action => "show" })
  
  # UPDATE
  
  post("/modify_response/:path_id", { :controller => "responses", :action => "update" })
  
  # DELETE
  get("/delete_response/:path_id", { :controller => "responses", :action => "destroy" })

  #------------------------------

  # Routes for the Message resource:

  # CREATE
  post("/send_message", { :controller => "messages", :action => "create" })
          
  # READ
  get("/messages", { :controller => "messages", :action => "index" })
  
  get("/messages/:path_id", { :controller => "messages", :action => "show" })

  get("/cover/:request_id", { :controller => "messages", :action => "cover" })
  
  # UPDATE
  
  post("/modify_message/:path_id", { :controller => "messages", :action => "update" })
  
  # DELETE
  get("/delete_message/:path_id", { :controller => "messages", :action => "destroy" })

  #------------------------------

  # Routes for the Job resource:

  # CREATE
  post("/insert_job", { :controller => "jobs", :action => "create" })
          
  # READ
  get("/jobs", { :controller => "jobs", :action => "index" })
  
  get("/jobs/:path_id", { :controller => "jobs", :action => "show" })
  
  # UPDATE
  
  post("/modify_job/:path_id", { :controller => "jobs", :action => "update" })
  
  # DELETE
  get("/delete_job/:path_id", { :controller => "jobs", :action => "destroy" })

  #------------------------------

  # Routes for the Company resource:

  # CREATE
  post("/insert_company", { :controller => "companies", :action => "create" })
          
  # READ
  get("/companies", { :controller => "companies", :action => "index" })
  
  get("/companies/:path_id", { :controller => "companies", :action => "show" })
  
  # UPDATE
  
  post("/modify_company/:path_id", { :controller => "companies", :action => "update" })
  
  # DELETE
  get("/delete_company/:path_id", { :controller => "companies", :action => "destroy" })

  #------------------------------

  # Routes for the Coverletter resource:

  # CREATE
  post("/insert_coverletter", { :controller => "coverletters", :action => "create" })
          
  # READ
  get("/coverletters", { :controller => "coverletters", :action => "index" })
  
  get("/coverletters/:path_id", { :controller => "coverletters", :action => "show" })
  
  # UPDATE
  
  post("/modify_coverletter/:path_id", { :controller => "coverletters", :action => "update" })
  
  # DELETE
  get("/delete_coverletter/:path_id", { :controller => "coverletters", :action => "destroy" })

  #------------------------------

  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"
  
  get("/", {:controller => "home", :action => "index"})
  get("/start", {:controller => "home", :action => "start"})
  get("/generate/:path_id", { :controller => "home", :action => "generate" })
  get("/user/show", {:controller => "user", :action => "show"})
  
end
