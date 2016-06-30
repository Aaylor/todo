
let mkdir path =
  let exists = Sys.file_exists path in
  if exists && not (Sys.is_directory path) then
    failwith (Format.sprintf "'%s' already exists and is not a directory." path)
  else if not exists then
    Unix.mkdir path 0o740

let with_resource open_ close f =
  let resource = open_ () in
  try
    let result = f resource in
    close resource;
    result
  with exn -> close resource; raise exn

let with_input path f =
  with_resource (fun () -> open_in path) close_in f

let with_output path f =
  with_resource (fun () -> open_out path) close_out f
