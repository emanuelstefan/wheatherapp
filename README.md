# How Hot is it Today?

`How Hot is it Today?` is a demo Rails application that can tell you if the weather is either cold, warm or hot, based on some predefined (but editable) ranges.

## Installation

after cloning the project, go into its folder (via `cd`) and bundle it:

```bash
bundle install
```

after which the migrations will take care of the database structure and initial data (for those [cold,warm,hot] initial values). Run:

```bash
rake db:migrate
```

and finally run the Rails server to see it in action (at localhost:3000)

```bash
rails s
```

Enjoy!
