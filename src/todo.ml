
open TodoConf
open TodoCommand

(* Cli parsing *)

(* FIXME *)
let help =
  "todo [add|list|done] ...\
   \n\
  todo add <params...>  : add a new todo task with params concatened as todo\
                          text.\
   \n\
  todo list [todo|done] : show open task\
   \n\
  todo done <params...> : where params are list of integers. close todo task."

let print_help_and_fail () =
  Format.printf "%s" help;
  exit 1

let parse_command () : (module Command) =
  if Array.length Sys.argv < 2 then print_help_and_fail ();
  match CommandTable.lookup_command Sys.argv.(1) with
  | None -> print_help_and_fail ()
  | Some m -> m

let cut_argv () =
  Array.(sub Sys.argv 2 (length Sys.argv - 2))


(* Initialization *)

let () =
  let folders = [base_folder; todo_folder; done_folder] in
  List.iter TodoIO.mkdir folders

let () =
  let (module Cmd) = parse_command () in
  let argv = cut_argv () in
  let result = Cmd.parse argv in
  Cmd.execute result
