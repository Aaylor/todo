
open Format
open TodoAST
open TodoConf
open TodoIO

let id_file = Filename.concat base_folder ".id"

let fresh_identifier () =
  if not (Sys.file_exists id_file) then 0
  else
    let id = with_input id_file (fun c -> int_of_string (input_line c)) in
    with_output id_file (fun c -> output_string c (sprintf "%d" (id + 1)));
    id

let read_title () =
  Format.printf "What is the short title ? > %!";
  read_line ()

let add ~title ~due_date ~priority ~description =
  let todo = {
    title = Option.none_apply ~f:read_title title;
    creation_date = "";
    due_date;
    priority = Option.may ~default:0 priority;
    description
  } in
  let id = fresh_identifier () in
  let filename = Filename.concat todo_folder (sprintf "%05d.todo" id) in
  with_output filename (fun c ->
    let fmt = formatter_of_out_channel c in
    Format.printf "%a" pp_todo todo;
    Format.fprintf fmt "%a%!" pp_todo todo);
  Format.printf "Done.%!"

let move_done_file id =
  let filename = sprintf "%05d.todo" id in
  let todo_file = Filename.concat todo_folder filename in
  let done_file = Filename.concat done_folder filename in
  if not (Sys.file_exists todo_file) then assert false; (* FIXME *)
  Sys.rename todo_file done_file

let done_ ids =
  List.iter move_done_file ids

type list_kind =
  | Todo
  | Done

let list kind =
  let folder = match kind with
    | Todo -> todo_folder
    | Done -> done_folder
  in
  let filenames = Sys.readdir folder in
  Array.sort String.compare filenames;
  Array.iter (fun name ->
    let filename = Filename.concat folder name in
    let id = int_of_string String.(sub name 0 (index name '.')) in
    with_input filename (fun chan ->
      let line = input_line chan in
      printf "[%05d] %s@\n" id line)
  ) filenames
