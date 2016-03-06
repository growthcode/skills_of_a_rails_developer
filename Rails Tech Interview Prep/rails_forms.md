# Rails Forms

- authenticity_token
    - Generated with the ` form_for ` and ` form_tag `
    - Prevents cross-site request forgery protection
    - hidden form tag generated with authenticity token

- search forms
    - use ` GET `
        - allows users to bookmark a specific search result

- ` form_tag({controller: name, action: name}, {method: 'get', class: "form"}) `
    - take two options
        - Path for Action
        - Options Hash
            - Method is in Options Hash, because a default exists.

- ` form_for(@object), url: {action: "create"}, html: {class: "form"} `
    - ` @object ` is the actual object being edited
    - URL HASH
        - Routing Options
    - HTMLS HASH
        - html options
    - Rails automatically adds a form ID, CLASS... related to the object

- ` accepts_nested_attributes_for :associated_obj `
    - method required on the model of the object that will be using nested attributes
    - adds ` ***_attributes= ` or ` associated_obj_attributes= ` method for the :associate_obj, allowing:
        - Create
        - Update
        - Destroy, if option set to ` true `
            - ` allow_destroy: true `
            - If the hash of attributes for an object contains the key ` _destroy ` with a value of 1 or true then the object will be destroyed.
                - ` <%= addresses_form.check_box :_destroy %>`
            - Include ` :_destroy ` in the whitelisted params
    - Useful to ignore sets of fields that the user has not filled in.
        - To reject blank fields, simply pass ` :all_blank `
            - doesn't reject ` :_destroy ` (and it shouldn't)
        - Control which fields, ad ` lambda `, for each field.
            - ` reject_if: lambda {|attr| attr['name'].blank?} `


    - this new method name will be expected in the params hash
    - example: ` accepts_nested_attributes_for :addresses `
        - params hash, see ` addresses_attributes `:
        ```
        {
            'person' => 'name',
            addresses_attributes => {
                'city' => 'Omaha',
                'city' => 'San Francisco'
            }
        }
        ```

- Nested Strong Parameters
    - ` params.require(:main_obj).permit(:name, ***_attributes: [:id, :kind, :_destroy]) `
    - Uses the ` ***_attributes ` format set to an array of approved nested fields
        - This formate setup via the ` accepts_nested_attributes_for ` in the main object's model




- ` #build ` example: ` @object.nested#build `
    - So this anywhere there is a blank nested object
    - Do this as many times as you need empty nested forms.
    - Build as many empty nested objects as you need.
        - ` 3.times { @object.nested#build } `
    - ` fields_for ` renders its block once for every element of the association like ` each `.
        - In particular, if a person has no addresses it renders nothing.
        - A common pattern is for the controller to build one or more empty children so that at least one set of fields is shown to the user.


- ` fields_for ` helper
    - for editing additional model objects with same form, like:
        - associated objects, like a person's spouse
        - ` has_one ` relationship
            - Person ` has_one ` Spouse
            ```
            <%= form_for @person do | f | %>
                <%= f.text_field :name %>
                    <%= f.fields_for @person.spouse do | spouse_form |%>
                    <%= spouse_form.text_field :first_name %>
                    <%= spouse_form.text_field :last_name %>
                <% end %>
            <% end %>
            ```
        - ` has_many ` relationship
            - Person ` has_many ` Addresses
            ```
            <%= form_for @person do | f | %>
                <%= f.text_field :name %>
                    <% @person.addresses.each do | address | %>
                        <%= f.fields_for address do | address_form |%>
                        <%= address_form.text_field :city %>
                    <% end %>
                <% end %>
            <% end %>
            ```
        - other objects not related to first but available to edit

    - ` index: ### ` option, custom setting the keys inside the nested ` **_attributes ` hash
        - NOT needed, should try to do without first.
        - ` has_many ' option is more for why it's used
            - ` <%= f.fields_for address, index: address.id do | address_form |%> `
        - Useful to easily locate which object is being edited
        - Inside the nested object, it sorts/organizes/arragnges them by the ` index `'s number value
            - Without ` index `: ` person[addresses][city] `
                - Resulting Hash:
                ```
                { 'person' => {
                        'name' = 'Hethe',
                        'addresses' => {
                            { 'city' => 'Omaha' },
                            { 'city' => 'San Francisco' }
                        }
                    }
                }
                ```
            - With ` index ` with value of address Id: ` person[address][index][city] `
                - Resulting Hash:
                ```
                { 'person' => {
                        'name' => 'Hethe',
                        'addresses' => {
                            '25' => { 'city' => 'Omaha' },
                            '26' => { 'city' => 'San Francisco' }
                        }
                    }
                }
                ```


- UPLOADING files
    - Encoding MUST be set to ` "multipart/ form-data" `. This is in the form tag.
        - If you use form_for, this is done automatically.
        - If you use form_tag, you must set it yourself.
    - What is uploaded:
        - The object in the params hash is an instance of a subclass of IO.
        - Use ` File I/O ` to manipulate the object.
        - Potential tasks: Storing File on disk, sending to Amazon S3, ect.
        - AJAX uploads have more difficulty.
            - can't use ` remote: true `
            - JavaScript cannot read files from your harddrive and so can't be uploaded.
            - A common work around is an iframe that serves as the traget for the form submission.



# Setting up nested forms

1. Add associations to models
1. Add ` #accepts_nested_attributes_for ` to models you want nested forms to work on.
1. Determine your ` #accepts_nested_attributes_for ` options:
    - ` allow_destroy: false ` (default: false)
    - ` reject_if: :all_blank ` (default: no rejects)
1. Add ` ***_attributes ` and associated fields to the model's strong parameters.
1. Add ` @object.nested#build ` anywhere, where there is a blank nested object
    - Build as many empty nested objects as you need.
        - ` 3.times { @object.nested#build } `
    - Will automatically populated on edit


---------

Ruby on Rails. Ruby on Rails Guides  v2 (Kindle Locations 4469-4470). Ruby on Rails.
    You can also pass a block to select helper: <%= f.select(: city_id) do %> <% [[' Lisbon', 1], [' Madrid', 2]]. each do | c | -%> <%= content_tag(: option, c.first, value: c.last) %> <% end %> <% end %>
    If you are using select (or similar helpers such as collection_select, select_tag) to set a belongs_to association you must pass the name of the foreign key (in the example above city_id),
    As the name implies, this only generates option tags.
        <%= options_from_collection_for_select(City.all, :id, :name) %>
    As with other helpers, if you were to use the collection_select helper on a form builder scoped to the @person object, the syntax would be:
        <%= f.collection_select(:city_id, City.all, :id, :name) %>
    To recap, options_from_collection_for_select is to collection_select what options_for_select is to select.







