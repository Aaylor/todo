
open Format
open TodoConf
open TodoIO

open Resource.Infix

let identifier_file = Filename.concat base_folder ".id"

let fresh_identifier () =
  if not (Sys.file_exists identifier_file) then 0
  else
    with_input identifier_file >>+ fun chan ->
    int_of_string (input_line chan)

let add msg =
  let id = fresh_identifier () in
  let filename = Filename.concat todo_folder (sprintf "%05d.todo" id) in
  with_output filename >>+ fun c -> output_string c msg;
  with_output identifier_file >>+ fun c -> output_string c (sprintf "%d" id)

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
    with_input filename >>+ fun chan ->
    let line = input_line chan in
    printf "[%05d] %s@\n" id line
  ) filenames
