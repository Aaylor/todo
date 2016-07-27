
type todo = {
  id: int;
  title: string;
  creation_date: float;
  due_date: float option;
  priority: int;
  description: string;
}

let empty =
  { id = -1; title = ""; creation_date = 0.; due_date = None;
    priority = 0; description = "" }

let deserialize filename : todo =
  TodoIO.with_input filename Marshal.from_channel

let serialize (todo : todo) =
  Marshal.to_string todo [ Marshal.No_sharing ]

let pp_todo ~verbose fmt todo =
  let open Format in
  if verbose then begin
    let ppo fmt t = fprintf fmt "%f" t in
    fprintf fmt "ID: %d@\n" todo.id;
    fprintf fmt "TITLE: %s@\n" todo.title;
    fprintf fmt "CREATION DATE: %a@\n" ISO8601.Permissive.pp_datetime todo.creation_date;
    fprintf fmt "DUE DATE: %a@\n" Option.(pp_option ~ppo) todo.due_date;
    fprintf fmt "PRIORITY: %d@\n" todo.priority;
    fprintf fmt "---@\n";
    fprintf fmt "%s" todo.description
  end else
    fprintf fmt "[%05d] %s" todo.id todo.title

