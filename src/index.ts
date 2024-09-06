import Main from "./Main.elm";
import shoes from "./data.js";
import "temporal-polyfill/global";

Main.init({
  node: document.body,
  flags: {
    shoes,
    now: Temporal.Now.instant(),
    currentOffset: Temporal.Now.zonedDateTimeISO().offsetNanoseconds / 1e9,
  },
});
