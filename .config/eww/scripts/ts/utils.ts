import { $ } from "bun";

export function updateEww(variable: string, value: string) {
    return $`eww update ${variable}='${value}`
}