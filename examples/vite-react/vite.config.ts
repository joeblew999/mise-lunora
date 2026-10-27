import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'
import { lunora } from "@lunora/vite";

// https://vite.dev/config/
export default defineConfig({
  plugins: [lunora(), react()],
})
