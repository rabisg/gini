#Checks whether `value` is contained in `list`
Handlebars.registerHelper 'contains', (list, value) -> _.contains list, value

#Provides `console.log` inside Templates
Handlebars.registerHelper 'log', (data) -> console.log data
