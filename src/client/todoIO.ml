
let mkdir path =
  let exists = Sys.file_exists path in
  if exists && not (Sys.is_directory path) then
    failwith (Format.sprintf "'%s' already exists and is not a directory." path)
  else if not exists then
    Unix.mkdir path 0o740

let with_input path =
  Resource.with_resource ((fun () -> open_in path), close_in)

let with_output path =
  Resource.with_resource (
    (fun () -> open_out path),
    (fun c -> flush c; close_out c)
  )
