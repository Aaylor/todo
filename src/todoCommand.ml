
open Format
open TodoConf
open TodoIO

exception ParseFailure of string
exception ExecutionFailure of string

let parse_failure msg = raise (ParseFailure msg)
let execution_failure msg = raise (ExecutionFailure msg)

let () =
  Printexc.register_printer (fun exn ->
    match exn with
    | ParseFailure msg -> Some (sprintf "ParseFailure: %s@\n" msg)
    | ExecutionFailure msg -> Some (sprintf "ExecutionFailure: %s@\n" msg)
    | _ -> None
  )

module type Command = sig
  type t
  val pprint : formatter -> t -> unit
  val parse : string array -> t
  val execute : t -> unit
end

module CommandTable : sig
  val register_command : string -> (module Command) -> unit
  val lookup_command : string -> (module Command) option
end = struct
  let command_table = Hashtbl.create 7

  let register_command name (m : (module Command)) =
    Hashtbl.add command_table name m

  let lookup_command name =
    try Some (Hashtbl.find command_table name)
    with Not_found -> None
end

module ListCommand : Command = struct
  type t =
    | Todo
    | Done

  let pprint fmt t =
    fprintf fmt "List: %s@\n"
      (match t with
       | Todo -> "Todo"
       | Done -> "Done")

  let parse argv =
    let argc = Array.length argv in
    if argc = 0 then Todo
    else if argc <> 1 then parse_failure "'list' requires only one argument"
    else match argv.(0) with
      | "todo" -> Todo
      | "done" -> Done
      | c -> parse_failure (sprintf "'%s' doesn't exists for list." c)

  let get_folder = function
    | Todo -> todo_folder
    | Done -> done_folder

  let execute t =
    let folder = get_folder t in
    let filenames = Sys.readdir folder in
    Array.sort String.compare filenames;
    Array.iter (fun name ->
      let filename = Filename.concat folder name in
      let id = int_of_string String.(sub name 0 (index name '.')) in
      with_input filename (fun channel ->
        let line = input_line channel in
        printf "[%05d] %s@\n" id line
      )
    ) filenames
end

module AddCommand : Command = struct
  type t = string

  let id_file = Filename.concat base_folder ".id"

  let fresh_id =
    if not (Sys.file_exists id_file) then 0
    else
      with_input id_file (fun channel ->
        int_of_string (input_line channel) + 1
      )

  let pprint fmt t = fprintf fmt "Add \"%s\"" t

  let parse argv =
    if Array.length argv = 0 then
      parse_failure "add command requires at least one parameter"
    else begin
      let buffer = Buffer.create 13 in
      Array.iter (fun a ->
        Buffer.add_string buffer a;
        Buffer.add_char buffer ' '; (* FIXME: trailing space *)
      ) argv;
      Buffer.contents buffer
    end

  let execute t =
    let filename = Filename.concat todo_folder (sprintf "%05d.todo" fresh_id) in
    with_output filename (fun channel -> output_string channel t);
    with_output id_file (fun chan -> output_string chan (sprintf "%d" fresh_id))
end

module DoneCommand : Command = struct
  type t = int list

  let pprint fmt t =
    let pp_sep fmt () = fprintf fmt ", " in
    fprintf fmt "Done @[[%a]@]@\n"
      (pp_print_list ~pp_sep pp_print_int) t

  let parse argv =
    Array.fold_left (fun acc elt ->
      try int_of_string elt :: acc
      with Failure _ ->
        parse_failure (sprintf "'%s' was expected to be an integer" elt)
    ) [] argv

  let move_file_with_identifier id =
    let filename = sprintf "%05d.todo" id in
    let todo_file = Filename.concat todo_folder filename in
    let done_file = Filename.concat done_folder filename in
    if not (Sys.file_exists todo_file) then
      execution_failure (sprintf "The todo task %d does not exists." id);
    Sys.rename todo_file done_file

  let execute t =
    List.iter move_file_with_identifier t
end

let () =
  CommandTable.register_command "list" (module ListCommand);
  CommandTable.register_command "add" (module AddCommand);
  CommandTable.register_command "done" (module DoneCommand)
