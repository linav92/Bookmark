# Prueba Marcadores 🚀

- Para realizar esta prueba debes haber estudiado previamente todo el material
disponibilizado correspondiente al módulo.
- Una vez terminada la prueba, sube el proyecto a github.

## Pre-requisitos 📋
Se requiere la instalación de el lenguaje de programación Ruby, el framework Rails, Bootstrap, para obtener datos la gema Faker y por último para agregar los gráficos Chartkick y Highcharts

**Instalación de bootstrap 4 en Rails 6** 🔧
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
Por último, dirigirse a `app/assets/stylesheets` y al archivo application.css se le cambia el nombre por **applications.scss**, se elimina el manifiesto y se importa bootstrap
```sh
@import "bootstrap/scss/bootstrap";
```
Con estos pasos ya se tiene instalado Bootstrap en el proyecto y está listo para ser usado.

**Instalación de la gema Faker**🔧
Para su instalación se debe agregar en el archivo **Gemfile** la gema `gem 'faker'` y ejecutar el *bundle*
```sh
gem 'faker'
```

**Instalación de la gema Chartkick y Highcharts**🔧
Para su instalación se debe agregar en el archivo **Gemfile** la gema `gem 'chartkick'` y ejecutar el *bundle*
```sh
gem "chartkick"
```
En el editor de texto de preferencia, dirigirse a `app/javascript/packs/application.js` es aqui donde se agrega el require 
```sh
require("chartkick")
require("chart.js")
```
Por último ejecutar el comando yarn en la consola
```sh
yarn add highcharts
```
Para volver a dirigirse a `app/javascript/packs/application.js` y agregar la importación de Highcharts; para que funcione exitosamente, se debe agregar el comando `window.Highcharts` de lo contrario no encontrará las librerías para ver el gráfico
```sh
import Highcharts from 'highcharts';
window.Highcharts = Highcharts;
```

¡Y listo, ya se puede iniciar a trabajar!
# Descripción 📦 

Mientras navegamos por internet encontramos artículos y sitios web que nos parecen interesantes, pero que no tenemos tiempo de revisar en ese instante y tendemos a usar nuestros marcadores para dejarlos como referencia.
En nuestro browser sólo podemos agruparlos por tipo o alguna otra categorización que
hayamos definido previamente.
Necesitamos un sistema que nos permita extender la funcionalidad de los marcadores de tal manera que podamos agruparlos por categoría y que además podamos definir subtipos, por ejemplo video, artículo, paper u otro tipo. Las categorías pueden tener anidadas otras categorías y no existe límite de sub categorías. En cambio los tipos, sólo están a un nivel y no pueden existir subtipos.
Una de las particularidades de nuestro sistema de bookmarks, es que podemos compartir
listas, esto es, que dada cierta categoría o subcategoría podemos hacer que todas las
subcategorías sean públicas o privadas.

**Suponer:**
- El nivel de visibilidad (público o privado) de una lista de subcategorías está definido por la categoría que se ha consultado. Por ejemplo, si se consulta "Animales" y es privada, cada sub categoría será privada. Si se consulta "Mamíferos" (sub categoría de Animales) y ésta es pública, desde ese nivel hacia abajo es pública. Es decir, para efectos de mostrar data, sólo se debe considerar el nivel de visibilidad de la categoría que se está consultando.
- El sistema es colaborativo, no existe sistema de usuario, por lo que cualquier persona puede agregar o quitar elementos de una lista/categoría.

**Instrucciones**
Como desarrollador de software, te han encargado hacer lo siguiente
1. Entregar un diagrama de relaciones, de tal manera que explique cómo interactúa cada uno de los modelos.
2. Entregar un CRUD para la administración de Categorías, Marcador y Tipo
3. El formulario para agregar Marcadores debe ser enviado a través de una petición
AJAX y antes de ser enviado debe pedir confirmación.
4. Crear un endpoint que retorne un JSON con los datos de una categoría (debe incluir subcategorías y marcadores). El esquema del JSON de salida debe quedar a su criterio.
5. Inicialmente, nuestro sistema debe contener al menos 20 registros predefinidos.
6. Mostrar un gráfico de torta que muestre cómo están distribuidos los tipos de
marcadores.

**Punto 1:** Diagrama de relaciones
![alt text](https://github.com/linav92/Bookmark/blob/main/Prueba.png?raw=true)

El proyecto tiene 3 tablas principales: `Bookmark`, `Category` y `Kind` 
Y se creó dos tablas intermedias: `BookmarkCategories` y `BookmarkKinds` en las cuales obtienen el id de la taba `Bookmark`

**Punto2:** CRUD para la administración:
Se realiza los scaffolds para:
*Category:* Para crear se crea las referencias `parent_category` y `children_categories` con el fin de generar las categorias y subcategoías, esto permite la relación entre ellas.
El `bookmark_categories` es la tabla intermedia que se mostrará más adelante.
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
En el `index.html.erb`de *Category* se agrega `category.parent_category` para mostrar las categorías padres
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
En el controlador de *Bookmaker* (`bookmaker_controller.rb`) se indica en el *index* la creación de nuevos marcadores
```sh
def index
    @bookmarks = Bookmark.all
    @bookmark = Bookmark.new
  end
```

Por algun problema de rails 6 (no trabajen nunca con rails 6), se tuvo que crear los params (de bookmark como los de category_id) dentro del método create para que funcionara el formulario y se indica el `format.js`
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
En el formulario `form.html.erb` de *Bookmark* se debe agregar al inicio `remote: true` y pedir la confirmación de la creación del marcador `data: {confirm: 'Are you sure?'}`
```sh
<%= form_with(model: bookmark, remote: true) do |form| %>
 ...
  <div class="actions">
    <%= form.submit data: {confirm: 'Are you sure?'} %>
  </div>
<% end %>
```
Y se crea la vista `create.js.erb` en donde se aplica la creación por javascript, para ejecutar correctamente esta función se debe hacer el `yarn add jquery`, en caso se usó **Bootstrap** el cual ya tiene implementado **JQuery**
```sh
$("#bookmarks-list").append("<%= escape_javascript(render @bookmark, locals: { bookmark: @bookmark} ) %>")
```
Esto permite que se creen marcadores nuevos en la misma vista sin redireccionar y siendo formato js

**Punto 4:** JSON
Se crea un controlador Api `api_controller.rb` en el cual generamos el JSON para mostrar las categorías con sus respetivas subcategorías y marcadores
```sh
class ApiController < ApplicationController

    def api
        @category = Category.where("category_id is null").includes(:children_categories)
        render json: @category.to_json(:include =>[:children_categories,:bookmarks])
    end
end
```
Para poderlo visualizar, se creó un enlace en el menú (`shared/navbar.html.erb`) con el acceso a la API
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
Gracias a que se instaló la gema *Faker* nos hace mucho mas sencillo agregar datos, para ello hay que dirigirse al `db/seed.rb` y en ella se agrega 20 tipos, 10 categorías padres, 10 categorías hijos y por último se agrega los bookmarks con las respecticas categorías, como se presenta a continuación:
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
Por último se corre el seed en la consola
```sh
rails db:seed
```
**Punto 6:** Gráfico de torta
Se inicia creando un controlador `home_controller.rb` y dentro de ella se agrega un método index el cual se define los marcadores y se agrupan por tipos
```sh
def index
    @bookmarks = Bookmark.joins(:kinds).group("kinds.title").count
end
```
Por último, en la vista `home/index.html.erb` se agrega el gráfico de torta
```sh
<div>
    <%= pie_chart @bookmarks %>
</div>
```
# Construido con 🛠️

* Ruby [2.6.3] - Lenguaje de programación usado
* Rails [6.1.3]  - Framework web usado
* Bootstrap [4.5.3] - Framework de CSS usado
* JQuery-Rails [4.4.0] - JQuery en Rails
* Faker [2.17.0] - Gema Faker para generar datos
* Chartkick [3.4.2] - Gráficos

## Autores ✒️

* **Lina Sofía Vallejo Betancourth** - *Trabajo Inicial y documentación* - [linav92](https://github.com/linav92)


## Licencia 📄

Este proyecto es un software libre. 
