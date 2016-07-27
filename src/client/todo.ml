
open Cmdliner
open TodoConf

let add =
  let doc = "TODO" in
  let title =
    let doc = "TODO" in
    let docv = "TITLE" in
    Arg.(value & opt (some string) None & info ["t"; "title"] ~doc ~docv)
  in
  let due_date =
    let doc = "TODO" in
    let docv = "TITLE" in
    Arg.(value & opt (some string) None & info ["-d"; "date"] ~doc ~docv)
  in
  let priority =
    let doc = "TODO" in
    let docv = "PRIORITY" in
    Arg.(value & opt (some int) None & info ["p"; "priority"] ~doc ~docv)
  in
  let description =
    let doc = "TODO" in
    let docv = "DESCR" in
    Arg.(required & pos 0 (some string) None & info [] ~doc ~docv)
  in
  let add title due_date priority description =
    TodoClient.add ~title ~due_date ~priority ~description
  in
  Term.(pure add $ title $ due_date $ priority $ description ),
  Term.info ~version ~doc "add"

let done_ =
  let doc = "TODO" in
  let identifiers =
    let doc = "TODO" in
    let docv = "IDs" in
    Arg.(non_empty & pos 0 (list int) [] & info [] ~doc ~docv)
  in
  let done_ identifiers = TodoClient.done_ identifiers in
  Term.(pure done_ $ identifiers),
  Term.info ~version ~doc "done"

let list =
  let doc = "TODO" in
  let kind =
    let doc = "TODO" in
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
  let doc = "TODO" in
  let id =
    let doc = "TODO" in
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
