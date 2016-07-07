
include String

let split_first sep str =
  try
    let idx = index str sep in
    (sub str 0 idx, sub str (idx + 1) ((length str) - idx - 1))
  with Failure _ -> (str, "")
