import Config

config :nostrum,
	gateway_intents: [
		:guilds,
		:guild_bans,
		:guild_emojis,
		:guild_integrations,
		:guild_webhooks,
		:guild_invites,
		:guild_voice_states,
		:guild_messages,
		:guild_message_reactions,
		:guild_message_typing,
		:direct_messages,
		:direct_message_reactions,
		:direct_message_typing,
		:message_content,
		:guild_scheduled_events
	]

import_config("secret.exs")
