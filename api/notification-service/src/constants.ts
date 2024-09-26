import { createClient } from "@supabase/supabase-js";

export function supabaseClient() {
  return createClient(
    process.env.SUPABASE_URL ?? "",
    process.env.SUPABASE_KEY ?? ""
  );
}

export const tokensTable = "fcm_tokens";
