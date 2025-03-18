<script lang="ts">
	import Tooltip from '$lib/components/common/Tooltip.svelte';
	import Textarea from '$lib/components/common/Textarea.svelte';

	import { onMount, getContext } from 'svelte';

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
	let user: string = '';

	onMount(async () => {
		// permissions = await getUserPermissions(localStorage.token);
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
				<input
					class="w-full rounded-lg py-1.5 px-4 text-sm bg-gray-50 dark:text-gray-300 dark:bg-gray-850 outline-hidden"
					type="text"
					bind:value={user}
					placeholder={$i18n.t('User')}
					autocomplete="off"
				/>
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
						content={$i18n.t('Insert this into the source of an web page.')}
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
{`</script>`}
{`<st`+`yle>`}
{css}
{`</style>`}</textarea>
					</Tooltip>
				</div>
			</div>
		</div>
	</div>
</form>
