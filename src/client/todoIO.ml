
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

let ask ?(prompt = ">") question =
  Format.printf "%s %s %!" question prompt;
  String.trim (read_line ())

let rec ask_until ?(prompt = ">") ?(err = "Incorrect input.") q p =
  let answer = ask ~prompt q in
  if p answer then answer
  else begin
    Format.eprintf "%s@\n%!" err;
    ask_until ~prompt ~err q p
  end

let read_until ?(prompt = ">") ~header p =
  Format.printf "%s %s %!" header prompt;
  let buffer = Buffer.create 13 in
  let rec r () =
    let line = String.trim (read_line ()) in
    if p line then Buffer.contents buffer
    else (Buffer.add_string buffer line; Buffer.add_char buffer '\n'; r ())
  in
  r ()
