import { Command } from "@effect/cli"
import { BunContext, BunRuntime } from "@effect/platform-bun"
import { Console, Effect } from "effect"

const command = Command.make("use-flake", {}, () =>
	Console.log("use flake!")
)

const cli = Command.run(command, {
	name: "Viktor ClI",
	version: "v0.0.1"
})

cli(process.argv).pipe(Effect.provide(BunContext.layer), BunRuntime.runMain)
