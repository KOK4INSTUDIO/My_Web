/** @type {import('tailwindcss').Config} */
export default {
  darkMode: 'class',
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#fff1f1',
          100: '#ffe0e0',
          200: '#ffc1c1',
          300: '#ff9494',
          400: '#ff5c5c',
          500: '#ed2633',
          600: '#d61d2a',
          700: '#b31622',
          800: '#91131e',
          900: '#78121c'
        },
        accent: {
          DEFAULT: '#ed2633',
          red: '#ed2633',
          redDark: '#b31622',
          redLight: '#ff5c5c',
          white: '#ffffff',
          gray: '#6b7280',
          grayLight: '#f3f4f6',
          dark: '#1f2937'
        }
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
        display: ['Plus Jakarta Sans', 'sans-serif']
      },
      boxShadow: {
        card: '0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)',
        soft: '0 4px 6px -1px rgb(0 0 0 / 0.05), 0 2px 4px -2px rgb(0 0 0 / 0.05)',
        red: '0 10px 40px -10px rgba(237, 38, 51, 0.45)'
      }
    }
  },
  plugins: []
}
