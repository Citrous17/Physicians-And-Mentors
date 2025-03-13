module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*',
  ],
  theme: {
    extend: {
      colors: {
        primary: 'var(--primary-color)', 
        secondary: 'var(--secondary-color)', 
        accent: 'var(--accent-color)', 
        surface: 'var(--surface-color)', 
        text: 'var(--text-color)', 
        background: 'var(--background-color)',
        okHighlight: 'var(--ok-highlight-color)',
        okHighlightFaded: 'var(--ok-highlight-faded-color)',
        warnHighlight: 'var(--warn-highlight-color)',
        warnHighlightFaded: 'var(--warn-highlight-faded-color)',
      },
    },
  },
  plugins: [],
}