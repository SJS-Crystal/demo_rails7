# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "jquery", to: "/plugins/jquery.js"
pin 'adminlte', to: '/lte3/dist/js/adminlte.min.js'
pin 'template_demo', to: '/lte3/dist/js/demo.js'
pin "moment", to: "/plugins/moment.js", preload: true
pin "daterangepicker", to: "/plugins/daterangepicker/daterangepicker.js"
pin_all_from "app/javascript/controllers", under: "controllers"
