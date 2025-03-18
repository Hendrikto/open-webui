<script lang="ts">
	import Tooltip from '$lib/components/common/Tooltip.svelte';
	import Textarea from '$lib/components/common/Textarea.svelte';

	import { onMount, getContext } from 'svelte';

	import { getUsers } from '$lib/apis/users';

	const i18n = getContext('i18n');

	export let saveHandler: Function;

	let apiToken: string = '';
	let baseURL: string = window.location.protocol + '//' + window.location.host + '/api';
	let css: string = `#chat {
	display: flex;
	flex-direction: column;
	margin: 0 auto;
	width: min(80vw, 1200px);
}

#chat-input {
	margin-top: 1rem;
	padding: 0.5rem;
}

.message {
	width: 50%;
	padding: 1rem;
	border: 1px solid #888;
	border-radius: 0.5rem;
}

.message:not(:first-child) {
	margin-top: 0.5rem;
}

.message-assistant {
	float: left;
	background: lightblue;
}

.message-user {
	float: right;
	background: lightgreen;
}`;
	let model: string = '';

	onMount(async () => {
		const users = await getUsers(localStorage.token);
		const userSelect = document.getElementById("user-select");

		for (let i = 0; i < users.length; i++) {
			const user = users[i];

			const option = document.createElement("option");
			option.value = user.api_key;
			option.innerText = user.name;

			userSelect?.appendChild(option);
		}
	});
</script>

<form
	class="flex flex-col h-full justify-between space-y-3 text-sm"
	on:submit|preventDefault={async () => {
		saveHandler();
	}}
>
	<div class="space-y-3 overflow-y-scroll scrollbar-hidden h-full">
		<div>
			<div class="mb-2 text-sm font-medium">{$i18n.t('Chat Embeds')}</div>
			<div class="mb-2.5 flex flex-col w-full justify-between">
				<div class="mb-1 text-xs font-medium">{$i18n.t('User')}</div>
				<select
					id="user-select"
					class="dark:bg-gray-900 w-fit pr-8 rounded-sm px-2 text-xs bg-transparent outline-hidden text-right"
					bind:value={apiToken}
					placeholder="Select a user"
				></select>
				<div class="mb-1 text-xs font-medium">{$i18n.t('Model')}</div>
				<input
					class="w-full rounded-lg py-1.5 px-4 text-sm bg-gray-50 dark:text-gray-300 dark:bg-gray-850 outline-hidden"
					type="text"
					bind:value={model}
					placeholder={$i18n.t('Model')}
					autocomplete="off"
				/>
				<div class="mb-1 text-xs font-medium">{$i18n.t('Base URL')}</div>
				<input
					class="w-full rounded-lg py-1.5 px-4 text-sm bg-gray-50 dark:text-gray-300 dark:bg-gray-850 outline-hidden"
					type="text"
					bind:value={baseURL}
					placeholder={$i18n.t('Base URL')}
					autocomplete="off"
				/>
				<div class="mb-1 text-xs font-medium">{$i18n.t('Styling')}</div>
				<textarea
					class="w-full rounded-lg px-3 py-2 text-sm bg-gray-50 dark:text-gray-300 dark:bg-gray-850 outline-hidden h-full"
					bind:value={css}
				></textarea>
				<div class="mb-1 text-xs font-medium">{$i18n.t('Embed Code')}</div>
				<div class="flex w-full items-center relative">
					<Tooltip
						content={$i18n.t('Insert this into the source of a web page.')}
						placement="top-start"
						className="w-full"
					>
						<textarea
							class="w-full rounded-lg px-3 py-2 text-sm bg-gray-50 dark:text-gray-300 dark:bg-gray-850 outline-hidden h-full"
							disabled
						>
{`<div id="chat">
	<div id="chat-messages"></div>
	<input id="chat-input">
</div>`}
{`<script type="text/javascript">`}
	const bearerToken = "{apiToken}";
	const baseURL = "{baseURL}";
	const model = "{model}";
{`
	const chatInput = document.getElementById("chat-input");
	const chatMessages = document.getElementById("chat-messages");

	function createMessage(role, message) {
		const container = document.createElement("div");
		container.classList.add("message");
		container.classList.add("message-"+role);

		container.appendChild(document.createTextNode(message));

		return container;
	}

	chatInput.addEventListener("keypress", function() {
		if (event.key !== "Enter") {
			return;
		}

		const message = chatInput.value;

		chatMessages.appendChild(createMessage("user", message))
		chatInput.value = "";

		fetch(baseURL+"/chat/completions", {
			"method": "POST",
			"headers": {
				"Authorization": "Bearer "+bearerToken,
				"Content-Type": "application/json"
			},
			"body": JSON.stringify({
				"model": model,
				// TODO: include history
				"messages": [
					{"role": "user", "content": message}
				]
			})
		}).then(response => response.json())
			.then(json => chatMessages.appendChild(createMessage("assistant", json.choices[0].message.content)));
	});`}
{`</script>`}
{`<style`+` type="text/javascript">`}
{css}
{`</style>`}</textarea>
					</Tooltip>
				</div>
			</div>
		</div>
	</div>
</form>
