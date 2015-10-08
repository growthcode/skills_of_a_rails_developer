# Routing

(route cheat sheet)[http://ricostacruz.com/cheatsheets/rails-routes.html]

- Top Down preciseness
    - Must put specific routes above resources where wild card routes are
    - ` :id ` is a wild card... anything can go there.
    - if ` get /plans/polls ` is listed below after the show route of ` get /plans/:id ` then it will never reach the polls page... because it would go to the show page at ID of polls

- ` verb '/controller_pluralized/possible_action' `, to: 'controller#action'
- ` verb '/controller_pluralized/:id_as_symbol' `, to: 'controller#action'
- ` verb '/controller_pluralized/:id_as_symbol/possible_action' `, to: 'controller#action'

- Avoiding deeply nested routes
    - Only build routes with the minimum amount of information to uniquely identify the resource
        - By not adding member routes to the nested resource save shorten URL
        - Only need the previous owner ` has_many ` resource when:
            - need to know who the member or collection belongs to
        - Don't need the previous ` has_many ` resource when
            - you have the ID of the member resource
    ```
    resources do
        resources :comments, only: [:index, :new, :create]
    end
    resources :comments, only: [:show, :edit, :update, :destroy]
    ```


- Route Helpers: ` , as: :helper_words `
    - Generates:
        - helper_words_path
        - helper_words_url

- resources generates how many of each verb?
    - 4 ` get `'s
    - 1 ` post `
    - 1 ` patch/put `
    - 1 ` delete `

- which resource verbs require an :id Key?
    - The ones where specific things are being done to an already created instance
        - show
        - edit
        - patch (put)
        - delete
    - ` show ` and  ` edit ` are the only ` get `s that requires an :id key

- ` resources :photos ` generates:
    - ` get /photos ` => index
    - ` get /photos/new ` => new
    - ` get /photos/:id ' => show
    - ` get /photos/:id/edit ' => edit




- Strong Params ....
