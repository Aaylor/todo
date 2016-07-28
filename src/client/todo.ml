
open Cmdliner
open TodoConf

let add =
  let doc =
    "Add a task into the todo list. If no description is given, \
     then parameters are ignored, and it starts the interactive mode."
  in
  let title =
    let doc =
      "The short title of the task. If no title is given, it will be ask to \
       user in stdin."
    in
    let docv = "TITLE" in
    Arg.(value & opt (some string) None & info ["t"; "title"] ~doc ~docv)
  in
  let due_date =
    let doc = "The due date of the task. It uses the ISO8601 syntax." in
    let docv = "DUE DATE" in
    Arg.(value & opt (some string) None & info ["d"; "date"] ~doc ~docv)
  in
  let priority =
    let doc = "The priority level of the task." in
    let docv = "PRIORITY" in
    Arg.(value & opt (some int) None & info ["p"; "priority"] ~doc ~docv)
  in
  let description =
    let doc =
      "The longer description of the task. If the description is not set, the \
       interactive mode is activated."
    in
    let docv = "DESCR" in
    Arg.(value & pos 0 (some string) None & info [] ~doc ~docv)
  in
  let add title due_date priority description =
    match description with
    | None -> TodoClient.add_interactive ()
    | Some description -> TodoClient.add ~title ~due_date ~priority ~description
  in
  Term.(pure add $ title $ due_date $ priority $ description),
  Term.info ~version ~doc "add"

let done_ =
  let doc =
    "Change the task from a 'todo' state into a 'done' state.\
     Done states are not deleted, and can still be accessed to the command \
     'todo list done'."
  in
  let identifiers =
    let doc = "The list of task identifiers." in
    let docv = "IDs" in
    Arg.(non_empty & pos 0 (list int) [] & info [] ~doc ~docv)
  in
  let done_ identifiers = TodoClient.done_ identifiers in
  Term.(pure done_ $ identifiers),
  Term.info ~version ~doc "done"

let list =
  let doc = "Give the list of existing todo or done tasks." in
  let kind =
    let doc =
      "The kind of task to list. It can be 'done' or 'todo'.\
       If no kind is given, the default one is 'todo'."
    in
    let docv = "KIND" in
    Arg.(value & pos 0 (some string) None & info [] ~doc ~docv)
  in
  let list kind =
    let todo_kind = match kind with
      | None | Some "todo" -> TodoClient.Todo
      | Some "done" -> TodoClient.Done
      | _ -> assert false (* FIXME *)
    in
    TodoClient.list todo_kind
  in
  Term.(pure list $ kind),
  Term.info ~version ~doc "list"

let show =
  let doc = "Show a particular todo task, giving complete informations." in
  let id =
    let doc = "The task identifier." in
    let docv = "ID" in
    Arg.(required & pos 0 (some int) None & info [] ~doc ~docv)
  in
  Term.(pure TodoClient.show $ id),
  Term.info ~version ~doc "show"

(* Default *)

let default =
  Term.(ret (const (`Help (`Plain, None)))),
  Term.info ~version Sys.executable_name

(* Entry point *)

let commands = [
  add; done_; list; show
]

let () =
  let folders = [base_folder; todo_folder; done_folder] in
  List.iter TodoIO.mkdir folders

let () =
  match Term.eval_choice ~catch:false default commands with
  | `Error _ -> exit 1
  | _ -> exit 0
