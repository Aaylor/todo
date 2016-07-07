
open Sys

let getenv_or_empty key =
  try getenv key
  with Not_found -> ""
