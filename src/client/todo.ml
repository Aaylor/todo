
open Cmdliner
open TodoConf

let add =
  let doc = "TODO" in
  let description =
    let doc = "TODO" in
    let docv = "DESCR" in
    Arg.(required & pos 0 (some string) None & info [] ~doc ~docv)
  in
  let add description = TodoClient.add description in
  Term.(pure add $ description),
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

(* Default *)

let default =
  Term.(ret (const (`Help (`Plain, None)))),
  Term.info ~version Sys.executable_name

(* Entry point *)

let commands = [
  add; done_; list
]

let () =
  let folders = [base_folder; todo_folder; done_folder] in
  List.iter TodoIO.mkdir folders

let () =
  match Term.eval_choice ~catch:false default commands with
  | `Error _ -> exit 1
  | _ -> exit 0
