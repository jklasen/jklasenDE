/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // Forge — deep blacks for backgrounds
        forge: {
          50: '#f7f7f6',
          100: '#e6e6e4',
          200: '#c2c2bf',
          300: '#9a9a96',
          400: '#5f5f5b',
          500: '#3a3a37',
          600: '#26261f', // (deprecated, use 950)
          700: '#1c1c17',
          800: '#141410',
          900: '#0c0c0a',
          950: '#050504',
        },
        // Bone — parchment / aged white for text & frames
        bone: {
          50: '#fdfcf8',
          100: '#f6f3e9',
          200: '#ebe5cf',
          300: '#dcd1ad',
          400: '#c9b985',
          500: '#b39e63',
          600: '#8e7c47',
          700: '#6b5c33',
          800: '#473d22',
          900: '#2a2414',
        },
        // Blood — viking red accent
        blood: {
          50: '#fdf2f2',
          100: '#fbe0e0',
          200: '#f5b8b8',
          300: '#ec8a8a',
          400: '#dc4f4f',
          500: '#b81d1d',
          600: '#8b0000', // signature
          700: '#6b0202',
          800: '#4a0202',
          900: '#2c0101',
        },
        // Ember — warm amber for highlights
        ember: {
          400: '#f59e0b',
          500: '#d97706',
          600: '#b45309',
        },
        // Keep primary/accent aliases for any old refs
        primary: {
          50: '#fdf2f2',
          100: '#fbe0e0',
          200: '#f5b8b8',
          300: '#ec8a8a',
          400: '#dc4f4f',
          500: '#b81d1d',
          600: '#8b0000',
          700: '#6b0202',
          800: '#4a0202',
          900: '#2c0101',
          950: '#1a0101',
        },
        accent: {
          400: '#f59e0b',
          500: '#d97706',
          600: '#b45309',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
        display: ['Cinzel', 'Georgia', 'serif'],
        carved: ['Metamorphous', 'Cinzel', 'Georgia', 'serif'],
        rune: ['"MedievalSharp"', 'Cinzel', 'serif'],
        mono: ['"JetBrains Mono"', 'ui-monospace', 'monospace'],
      },
      backgroundImage: {
        'forge-grain': "url(\"data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='3' stitchTiles='stitch'/%3E%3CfeColorMatrix values='0 0 0 0 0.05 0 0 0 0 0.05 0 0 0 0 0.04 0 0 0 0.35 0'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E\")",
      },
      boxShadow: {
        'rune': '0 0 0 1px rgba(220,209,173,0.15), 0 30px 60px -20px rgba(0,0,0,0.8)',
        'blood': '0 0 24px -4px rgba(139,0,0,0.6)',
      },
    },
  },
  plugins: [],
};
