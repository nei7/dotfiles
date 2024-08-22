import { $ } from "bun";

export function updateEww(variable: string, value: string) {
    console.log(value)
    return $`eww update ${variable}='${value}`
}