import Main from "./Main.elm";
import shoes from "./data.js";

Main.init({
  node: document.body,
  flags: shoes,
});
