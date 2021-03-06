# Prueba Marcadores 馃殌

- Para realizar esta prueba debes haber estudiado previamente todo el material
disponibilizado correspondiente al m贸dulo.
- Una vez terminada la prueba, sube el proyecto a github.

## Pre-requisitos 馃搵
Se requiere la instalaci贸n de el lenguaje de programaci贸n Ruby, el framework Rails, Bootstrap, para obtener datos la gema Faker y por 煤ltimo para agregar los gr谩ficos Chartkick y Highcharts

**Instalaci贸n de bootstrap 4 en Rails 6** 馃敡
Lo primero es agregar bootstrap en el proyecto con el comando, esto genera 3 nuevas dependencia
```sh
yarn add bootstrap jquery popper.js
```
En el editor de texto de preferencia, dirigirse a config/webpack/enviroment.js es aqui donde generamos las dependencias
```sh
const { environment } = require('@rails/webpacker')
const webpack = require("webpack")
environment.plugins.append("Provide", 
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default']
    })
)
module.exports = environment
```
Lo siguiente es dirigirse a `app/javascript/packs/application.js` e importar bootstrap
```sh
 import 'bootstrap'
 ```
Por 煤ltimo, dirigirse a `app/assets/stylesheets` y al archivo application.css se le cambia el nombre por **applications.scss**, se elimina el manifiesto y se importa bootstrap
```sh
@import "bootstrap/scss/bootstrap";
```
Con estos pasos ya se tiene instalado Bootstrap en el proyecto y est谩 listo para ser usado.

**Instalaci贸n de la gema Faker**馃敡
Para su instalaci贸n se debe agregar en el archivo **Gemfile** la gema `gem 'faker'` y ejecutar el *bundle*
```sh
gem 'faker'
```

**Instalaci贸n de la gema Chartkick y Highcharts**馃敡
Para su instalaci贸n se debe agregar en el archivo **Gemfile** la gema `gem 'chartkick'` y ejecutar el *bundle*
```sh
gem "chartkick"
```
En el editor de texto de preferencia, dirigirse a `app/javascript/packs/application.js` es aqui donde se agrega el require 
```sh
require("chartkick")
require("chart.js")
```
Por 煤ltimo ejecutar el comando yarn en la consola
```sh
yarn add highcharts
```
Para volver a dirigirse a `app/javascript/packs/application.js` y agregar la importaci贸n de Highcharts; para que funcione exitosamente, se debe agregar el comando `window.Highcharts` de lo contrario no encontrar谩 las librer铆as para ver el gr谩fico
```sh
import Highcharts from 'highcharts';
window.Highcharts = Highcharts;
```

隆Y listo, ya se puede iniciar a trabajar!
# Descripci贸n 馃摝 

Mientras navegamos por internet encontramos art铆culos y sitios web que nos parecen interesantes, pero que no tenemos tiempo de revisar en ese instante y tendemos a usar nuestros marcadores para dejarlos como referencia.
En nuestro browser s贸lo podemos agruparlos por tipo o alguna otra categorizaci贸n que
hayamos definido previamente.
Necesitamos un sistema que nos permita extender la funcionalidad de los marcadores de tal manera que podamos agruparlos por categor铆a y que adem谩s podamos definir subtipos, por ejemplo video, art铆culo, paper u otro tipo. Las categor铆as pueden tener anidadas otras categor铆as y no existe l铆mite de sub categor铆as. En cambio los tipos, s贸lo est谩n a un nivel y no pueden existir subtipos.
Una de las particularidades de nuestro sistema de bookmarks, es que podemos compartir
listas, esto es, que dada cierta categor铆a o subcategor铆a podemos hacer que todas las
subcategor铆as sean p煤blicas o privadas.

**Suponer:**
- El nivel de visibilidad (p煤blico o privado) de una lista de subcategor铆as est谩 definido por la categor铆a que se ha consultado. Por ejemplo, si se consulta "Animales" y es privada, cada sub categor铆a ser谩 privada. Si se consulta "Mam铆feros" (sub categor铆a de Animales) y 茅sta es p煤blica, desde ese nivel hacia abajo es p煤blica. Es decir, para efectos de mostrar data, s贸lo se debe considerar el nivel de visibilidad de la categor铆a que se est谩 consultando.
- El sistema es colaborativo, no existe sistema de usuario, por lo que cualquier persona puede agregar o quitar elementos de una lista/categor铆a.

**Instrucciones**
Como desarrollador de software, te han encargado hacer lo siguiente
1. Entregar un diagrama de relaciones, de tal manera que explique c贸mo interact煤a cada uno de los modelos.
2. Entregar un CRUD para la administraci贸n de Categor铆as, Marcador y Tipo
3. El formulario para agregar Marcadores debe ser enviado a trav茅s de una petici贸n
AJAX y antes de ser enviado debe pedir confirmaci贸n.
4. Crear un endpoint que retorne un JSON con los datos de una categor铆a (debe incluir subcategor铆as y marcadores). El esquema del JSON de salida debe quedar a su criterio.
5. Inicialmente, nuestro sistema debe contener al menos 20 registros predefinidos.
6. Mostrar un gr谩fico de torta que muestre c贸mo est谩n distribuidos los tipos de
marcadores.

**Punto 1:** Diagrama de relaciones
![alt text](https://github.com/linav92/Bookmark/blob/main/Prueba.png?raw=true)

El proyecto tiene 3 tablas principales: `Bookmark`, `Category` y `Kind` 
Y se cre贸 dos tablas intermedias: `BookmarkCategories` y `BookmarkKinds` en las cuales obtienen el id de la taba `Bookmark`

**Punto2:** CRUD para la administraci贸n:
Se realiza los scaffolds para:
*Category:* Para crear se crea las referencias `parent_category` y `children_categories` con el fin de generar las categorias y subcatego铆as, esto permite la relaci贸n entre ellas.
El `bookmark_categories` es la tabla intermedia que se mostrar谩 m谩s adelante.
```sh
class Category < ApplicationRecord
  belongs_to :parent_category, :class_name => "Category", :foreign_key => "category_id", :optional => true
  has_many :children_categories, class_name: "Category", :foreign_key => "category_id"
  
  #Relaciones con la tabla intermedia
  has_many :bookmark_categories
  has_many :bookmarks, through: :bookmark_categories
 
  validates :title, presence: true
  
  def to_s
    title
  end
end
```
*Kind*
```sh
class Kind < ApplicationRecord
    has_many :bookmark_kinds, dependent: :destroy
    has_many :bookmarks, through: :bookmark_kinds
    validates :title, uniqueness: true

    def to_s
        title
    end
end
```
*Bookmark*
```sh
class Bookmark < ApplicationRecord
    has_many :bookmark_categories, dependent: :destroy
    has_many :categories, through: :bookmark_categories

    has_many :bookmark_kinds, dependent: :destroy
    has_many :kinds, through: :bookmark_kinds
end
```
**CRUD TABLAS INTERMEDIAS**
*BookmarkCategory*
  ```sh
class BookmarkCategory < ApplicationRecord
  belongs_to :bookmark
  belongs_to :category
end
  ```
*BookmarkKind*
```sh
class BookmarkKind < ApplicationRecord
  belongs_to :bookmark
  belongs_to :kind
end
```
Para que el CRUD funcione correctamente , se debe modificar en las vistas la referencia a category, en el cual se crea un select con las category_id
```sh
<%= form_with(model: category) do |form| %>
  <% if category.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(category.errors.count, "error") %> prohibited this category from being saved:</h2>

      <ul>
        <% category.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="form-group">
    <%= form.label :title %>
    <%= form.text_field :title, class: 'form-control' %>
  </div>

  <div class="field">
    <%= form.label :is_public %>
    <%= form.check_box :is_public %>
  </div>

  <div class="form-group">
    <%= form.label :category_id %>
    <%= form.collection_select :category_id, Category.all, :id, :title,{ include_blank: true},{class: 'form-control'}  %>
  </div>

  <div class="actions">
    <%= form.submit %>
  </div>
<% end %>
```
En el `index.html.erb`de *Category* se agrega `category.parent_category` para mostrar las categor铆as padres
```sh
<td><%= category.parent_category%></td>
```
Y en el controlador `category_controller.rb` se llama a los strong params la `category_id`
```sh
def category_params
      params.require(:category).permit(:title, :is_public, :category_id)
end
```
No se realiza ningun cambio diferente al scaffold original para la *Kind*
En el controlador de *Bookmaker* (`bookmaker_controller.rb`) se indica en el *index* la creaci贸n de nuevos marcadores
```sh
def index
    @bookmarks = Bookmark.all
    @bookmark = Bookmark.new
  end
```

Por algun problema de rails 6 (no trabajen nunca con rails 6), se tuvo que crear los params (de bookmark como los de category_id) dentro del m茅todo create para que funcionara el formulario y se indica el `format.js`
```sh
 def create
    @bookmark = Bookmark.new
    @bookmark.title= params[:bookmark][:title]
    @bookmark.url= params[:bookmark][:url]
    @bookmark.category_ids= params[:bookmark][:category_id]
    @bookmark.kind_ids= params[:bookmark][:kind_id]
    @bookmark.save

    params[:bookmark][:category_ids].each do |cID| 
      if cID != ""
        @bookmarkcategory = BookmarkCategory.new
        @bookmarkcategory.category_id= cID
        @bookmarkcategory.bookmark_id = @bookmark.id
        @bookmarkcategory.save
      end 
    end 

    params[:bookmark][:kind_ids].each do |kID| 
      if kID != ""
        @bookmarkcategory = BookmarkKind.new
        @bookmarkcategory.kind_id= kID
        @bookmarkcategory.bookmark_id = @bookmark.id
        @bookmarkcategory.save
      end 
    end 
    
    respond_to do |format|
      if @bookmark.save
        format.js { }
        format.html { redirect_to @bookmark, notice: "Bookmark was successfully created." }
        format.json { render :show, status: :created, location: @bookmark }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end
```
En la vista de *Bookmark* index, renderiza dos vistas parciales: 1. el formulario  y 2. la lista de marcadores.
```sh
<p id="notice"><%= notice %></p>

<h1>Bookmarks</h1>
<div class="pb-4">
  <%= render "form", bookmark: @bookmark %>
</div>

<table class="table ">
  <thead>
    <tr>
      <th>Title</th>
      <th>Url</th>
      <th>Categories</th>
      <th>Kinds</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody id="bookmarks-list">
    <%= render 'index' %>
  </tbody>
</table>
```
En la vista parcial _index.html.erb se encuentra la lista de los marcadores con las respectivas categorias y tipo.
```sh
<% @bookmarks.each do |bookmark| %>
    <tr>
      <tr>
        <td><%= bookmark.title %></td>
        <td><%= bookmark.url %></td>
        <td>
          <ul>
            <% bookmark.categories.each do |c| %>
              <li><%= c %></li>
            <% end %>
          </ul>
        </td>
        <td>
          <ul>
            <% bookmark.kinds.each do |k| %>
              <li><%= k  %></li>
            <% end %>
          </ul>
        </td>
        <td><%= link_to 'Show', bookmark, remote: true %></td>
        <td><%= link_to 'Edit', edit_bookmark_path(bookmark), remote: true %></td>
        <td><%= link_to 'Destroy', bookmark, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
<% end %>
```
En el formulario `form.html.erb` de *Bookmark* se debe agregar al inicio `remote: true` y pedir la confirmaci贸n de la creaci贸n del marcador `data: {confirm: 'Are you sure?'}`
```sh
<%= form_with(model: bookmark, remote: true) do |form| %>
 ...
  <div class="actions">
    <%= form.submit data: {confirm: 'Are you sure?'} %>
  </div>
<% end %>
```
Y se crea la vista `create.js.erb` en donde se aplica la creaci贸n por javascript, para ejecutar correctamente esta funci贸n se debe hacer el `yarn add jquery`, en caso se us贸 **Bootstrap** el cual ya tiene implementado **JQuery**
```sh
$("#bookmarks-list").append("<%= escape_javascript(render @bookmark, locals: { bookmark: @bookmark} ) %>")
```
Esto permite que se creen marcadores nuevos en la misma vista sin redireccionar y siendo formato js

**Punto 4:** JSON
Se crea un controlador Api `api_controller.rb` en el cual generamos el JSON para mostrar las categor铆as con sus respetivas subcategor铆as y marcadores
```sh
class ApiController < ApplicationController

    def api
        @category = Category.where("category_id is null").includes(:children_categories)
        render json: @category.to_json(:include =>[:children_categories,:bookmarks])
    end
end
```
Para poderlo visualizar, se cre贸 un enlace en el men煤 (`shared/navbar.html.erb`) con el acceso a la API
```sh
<nav class="navbar navbar-expand-sm  sticky-top navbar-dark py-4" style="background-color: #76448A;">
    ...
            <ul class="navbar-nav">
                ... 
                <li class="nav-item"> <%= link_to 'Api', api_path, class:"nav-link" %></li>
            </ul>
  ...
</nav>
```
**Punto 5:** Registro pre definidos
Gracias a que se instal贸 la gema *Faker* nos hace mucho mas sencillo agregar datos, para ello hay que dirigirse al `db/seed.rb` y en ella se agrega 20 tipos, 10 categor铆as padres, 10 categor铆as hijos y por 煤ltimo se agrega los bookmarks con las respecticas categor铆as, como se presenta a continuaci贸n:
```sh
20.times do |i|
    title = Faker::Kpop.girl_groups + (i + 1).to_s
    Kind.create!(title: title)
end

10.times do |i|
    title = Faker::Kpop.solo + (i + 1).to_s
    is_public = [true, false].sample
    Seed = Category.create!(title: title, is_public: is_public)
    10.times do |j|
        title = Faker::Kpop.solo + (j + 1).to_s
        is_public = [true, false].sample
        category_id = Seed.id
        Category.create!(title: title, is_public: is_public, category_id: category_id)
    end
end

categories = Category.all
kinds = Kind.all

10.times do |i|
  title = Faker::Hipster.word + (i + 1).to_s
  url = Faker::Internet.url
  Bookmark.create!(title: title, url: url)
end

Bookmark.all.each do |b|
  3.times do 
    BookmarkCategory.create!(bookmark: b, category: categories.sample)
    BookmarkKind.create!(bookmark: b, kind: kinds.sample)
  end
end
```
Por 煤ltimo se corre el seed en la consola
```sh
rails db:seed
```
**Punto 6:** Gr谩fico de torta
Se inicia creando un controlador `home_controller.rb` y dentro de ella se agrega un m茅todo index el cual se define los marcadores y se agrupan por tipos
```sh
def index
    @bookmarks = Bookmark.joins(:kinds).group("kinds.title").count
end
```
Por 煤ltimo, en la vista `home/index.html.erb` se agrega el gr谩fico de torta
```sh
<div>
    <%= pie_chart @bookmarks %>
</div>
```
# Construido con 馃洜锔?

* Ruby [2.6.3] - Lenguaje de programaci贸n usado
* Rails [6.1.3]  - Framework web usado
* Bootstrap [4.5.3] - Framework de CSS usado
* JQuery-Rails [4.4.0] - JQuery en Rails
* Faker [2.17.0] - Gema Faker para generar datos
* Chartkick [3.4.2] - Gr谩ficos

## Autores 鉁掞笍

* **Lina Sof铆a Vallejo Betancourth** - *Trabajo Inicial y documentaci贸n* - [linav92](https://github.com/linav92)


## Licencia 馃搫

Este proyecto es un software libre. 
