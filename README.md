<a name="readme-top"></a>

<div align="center">
<h3><b>Catalog of my things</b></h3>
</div>

# 📗 Table of Contents

- [📖 About the Project](#about-project)
  - [🛠 Built With](#built-with)
    - [Tech Stack](#tech-stack)
    - [Key Features](#key-features)
- [💻 Getting Started](#getting-started)
  - [Setup](#setup)
  - [Prerequisites](#prerequisites)
  - [Install](#install)
  - [Usage](#usage)
  - [Run tests](#run-tests)
  - [Deployment](#triangular_flag_on_post-deployment)
- [👥 Authors](#authors)
- [🔭 Future Features](#future-features)
- [🤝 Contributing](#contributing)
- [⭐️ Show your support](#support)
- [🙏 Acknowledgements](#acknowledgements)
- [❓ FAQ (OPTIONAL)](#faq)
- [📝 License](#license)

# 📖 Catalog of my things <a name="about-project"></a>

This is a console app that can list items, add new item and save it to a file.
This app heavily use meta programming to make it easy to add new functionality.
Unlike other app, this app generate the UI and functionality automatically.
You can add new functionality by just creating a new class, follow the examples below.

# How to add new functionality

## 1. Simplest and straight forward way

All you need to do is create a new class in `lib/models` folder.
You must use `snake_case` for the filename and `PascalCase` for the class name.

Eg. `lib/models/my_new_model.rb`

```ruby
class MyNewModel
  def initialize(item1, item2) # You need to define initialize method with required attributes
    @item1 = item1 # these attributes are also required to show it in the UI
    @item2 = item2
  end
end
```

## 2. Simple way

Create a class in wherever you want and import it in the entry point file `main.rb`.
You can also directly create a new instance of the class in `main.rb` file.
But if you create on somewhere else, you need to import it in `main.rb` file.

Eg. `main.rb`

```ruby
require_relative 'lib/app'

# you can create the class here or import it from somewhere else
# you must follow the same rule as above `PascalCase` for the class name and `snake_case` for the filename or symbol
class MyNewModel
  def initialize(item1, item2) # You need to define initialize method with required attributes
    @item1 = item1 # these attributes are also required to show it in the UI
    @item2 = item2
  end
end

# after you create or import the class, you need to add it to the `extra_models` array
App.new(
  extra_models: %i[my_new_model], # <------ add you class in `snake_case` here
).start
```

## 3. For More Complex Classes(with associations)

You can do the same as above, but you need to define the associations in the class.
You have to follow the same rule as above `PascalCase` for the class name and `snake_case` for the filename or symbol.
Let's assume `User` has a `Address`

`lib/models/user.rb`

```ruby
require_relative 'address'

class User
  def initialize(name, address)
    @name = name
    @address = address
  end

  def self.depends_on
    %i[address] # <------ add the association here
  end
end
```

`lib/models/address.rb`

```ruby
class Address
  def initialize(street, city)
    @id = Random.rand(1000) # <------ you need to define an id to make associations work
    @street = street
    @city = city
  end

  # You should override this method to show the association in the UI
  # If you don't you will see like <Address:0x00007f8b9a8b1b80> in the UI
  def to_s
    "#{@street}, #{@city}"
  end
end
```

# Customization the UI

## Hide options

You can hide options in the UI by passing class name in `snake_case` to `hidden_list` or `hidden_add` array in `main.rb` file.

Eg. `main.rb`

```ruby
require_relative 'lib/app'

App.new(
  extra_models: %i[], # <---- you external classes
  hidden_list: %i[my_new_model], # This will hide the list option for `MyNewModel`
  hidden_add: %i[my_new_model], # This will hide the add option for `MyNewModel`
).start # <------ start will generate the UI
```

## Override Default Questions

By passing questions `questions` hash to `App.new` you can override the default questions.
If you want to accept boolean value you need to end you attribute name with `?` mark.
If you want to accept date value you need to end you attribute name with `_date`.

Eg. `main.rb`

```ruby
require_relative 'lib/app'

App.new(
  extra_models: %i[], # <---- you external classes
  questions: {
    my_new_model: {
      item1: 'Write you question whatever you want',
      item2?: 'Is this item2?', # <------- this will ask question with (y/n)  and convert to boolean value.
      item3_date: 'When is the item4 date?', # <---- this will ask question with (YYYY-MM-DD) and will convert to date.
    },
  },
).start # <------ start will generate the UI
```

## Use your own UI

If you want to use your own UI, you can create you own one.
`App` class provide `list_` and `add_` methods.
You can use these methods to create your own UI.

> You have to use plural form of the class name to call the `list_` method.

> You have to use singular form of the class name to call the `add_` method.

Eg. `main.rb`

```ruby
require_relative 'lib/app'

app = App.new(
  extra_models: %i[], # <---- you external classes
  questions: {} # <---- you can override the default questions here

  # You don't need to pass `hidden_list` and `hidden_add` here
  # These two will do nothing, because we are not calling the start method
  hidden_list: %i[],
  hidden_add: %i[]
) # Don't call start method it will generate the default UI


puts 'This is my own UI'
puts '1)List my awesome items' # <---- Assuming you have a class called `MyAwesomeItem` 
puts '2)Add new awesome item'
puts '3)Exit'

print 'Enter your choice: '
choice = gets.chomp.to_i

case choice
when 1
  app.list_my_awesome_items # <---- call the list method like this in plural form of the class name in snake_case
when 2
  app.add_my_awesome_item # <---- call the add method like this in singular form of the class name in snake_case
when 3
  puts 'Bye'
else
  puts 'Invalid choice'
end
```

> This readme is generated using [beadme](https://github.com/oyhpnayiaw/beadme).

## 🛠 Built With <a name="built-with"></a>

### Tech Stack <a name="tech-stack"></a>

Ruby

### Key Features <a name="key-features"></a>

- **Listing items**

- **Adding new item**

- **Everything takecare automatically**

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 💻 Getting Started <a name="getting-started"></a>

To get a local copy up and running, follow these steps.

### Prerequisites

In order to run this project you need: Ruby

### Setup

Clone the repo, run bundle and run `ruby main.rb`

### Install

Install this project with:

```sh
bundle
```

### Usage

To run the project, execute the following command:

```sh
ruby main.rb
```

### Run tests

To run tests, run the following command:

```sh
bundle exec rspec
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 👥 Authors <a name="authors"></a>

**Wai Yan Phyo**

- Github: [@oyhpnayiaw](https://github.com/oyhpnayiaw)
- Twitter: [@oyhpnayiaw](https://twitter.com/oyhpnayiaw)
- LinkedIn: [@oyhpnayiaw](https://linkedin.com/in/oyhpnayiaw)

**Rabecca Nabwire**

- Github: [@Becky449](https://github.com/Becky449)
- Twitter: [@rabeccanab](https://twitter.com/rabeccanab)
- LinkedIn: [@rabeccanabwire](https://www.linkedin.com/in/rabeccanabwire/)

**Innocent N.**

- GitHub: [@chaseknis](https://github.com/Chaseknis)
- Twitter: [@ChaseToTheWorld](https://twitter.com/chasetotheworld)
- LinkedIn: [Innocent N.](https://www.linkedin.com/in/innocent-n-200826252/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🔭 Future Features <a name="future-features"></a>

- I don't have any plan for this project yet.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🤝 Contributing <a name="contributing"></a>

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](../../issues/).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## ⭐️ Show your support <a name="support"></a>

If you like this project or find it useful, please consider giving it a ⭐️. Thanks!

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🙏 Acknowledgments <a name="acknowledgements"></a>

My coding partner and Microverse...

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 📝 License <a name="license"></a>

This project is [MIT](./LICENSE) licensed.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
