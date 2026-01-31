import { createClient } from "@supabase/supabase-js";
import dotenv from "dotenv";
dotenv.config();

const superbaseurl = process.env.SUPABASE_URL;
const superbaseanonkey = process.env.SUPABASE_ANON_KEY;

export const superbase = createClient(superbaseurl, superbaseanonkey);

export const BUCKET_NAME = "hotel_images";