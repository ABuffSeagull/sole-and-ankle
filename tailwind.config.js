import * as theme from "tailwindcss/defaultTheme";

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "src/**/*.elm"],
  theme: {
    colors: {
      white: "#FFFFFF",
      gray: {
        100: "#C9CECF",
        300: "#C9CECF",
        500: "#949A9C",
        700: "#60666C",
        900: "#313235",
      },
      primary: "#C5295D",
      secondary: "#6868D9",
    },
    extend: {
      fontFamily: {
        sans: ["Raleway", ...theme.fontFamily.sans],
      },
    },
  },
  plugins: [],
};
