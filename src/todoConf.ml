
let version = "0.0.1alpha"

let getenv what =
  try Sys.getenv what
  with Not_found -> ""

let base_folder = Filename.concat (getenv "HOME") ".todo"
let todo_folder = Filename.concat base_folder "todo"
let done_folder = Filename.concat base_folder "done"
