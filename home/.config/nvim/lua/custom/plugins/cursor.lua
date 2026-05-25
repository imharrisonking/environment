-- Cursor animations
return {
    'sphamba/smear-cursor.nvim',
    opts = {
        enabled = false,
        smear_between_buffers = false,
        smear_insert_mode = false,
        delay_after_key = 5,
        delay_event_to_smear = 5,
        filetypes_disabled = {
            'TelescopePrompt',
            'TelescopeResults',
            'snacks_picker_input',
            'snacks_picker_list',
        },
        stiffness = 0.9,
        trailing_stiffness = 0.7,
        distance_stop_animating = 0.3,
    },
}
