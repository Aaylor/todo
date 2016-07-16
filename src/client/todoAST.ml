
type todo = {
  title: string;
  creation_date: string;
  due_date: string option;
  priority: int;
  description: string;
}

let pp_todo fmt todo =
  let open Format in
  let ppo fmt t = fprintf fmt "%s" t in
  fprintf fmt "TITLE: %s@\n" todo.title;
  fprintf fmt "CREATION DATE: %s@\n" todo.creation_date;
  fprintf fmt "DUE DATE: %a@\n" Option.(pp_option ~ppo) todo.due_date;
  fprintf fmt "PRIORITY: %d@\n" todo.priority;
  fprintf fmt "---@\n";
  fprintf fmt "%s" todo.description
