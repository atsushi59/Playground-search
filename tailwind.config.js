module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        mono: ['Arial Unicode MS', 'ui-monospace', 'SFMono-Regular'],
        sans: ['Wawati SC', 'ui-sans-serif', 'system-ui'] 
      }
    }
  },
  plugins: [require("daisyui")],
}
