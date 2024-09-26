import { Logger } from "@firebase/logger";
import { createClient, SupabaseClient } from "@supabase/supabase-js";

export function supabaseClient():SupabaseClient {
  return createClient(
    process.env.SUPABASE_URL ?? "",
    process.env.SUPABASE_KEY ?? ""
  );
}

export const tokensTable = "fcm_tokens";
export const logger = new Logger("sk.apiv1");


