local sprite_state_info = {
	['image'] = 'resources/spritesheets/samus/suitstate1.png',
	['frame_width'] = 88,
	['frame_height'] = 104,
	['states'] = 2,
	['state_info'] = {
		{ -- still
			['poses'] = 4,
			['pose_info'] = {
				{
					['frames'] = 1,
					['start_row'] = 0,
					['start_column'] = 2,
					['delay'] = 0.1,
					['speed'] = 1,
					['mode'] = 1,
					['is_directional'] = true
				},
				{
					['frames'] = 1,
					['start_row'] = 0,
					['start_column'] = 2,
					['delay'] = 0.1,
					['speed'] = 1,
					['mode'] = 1,
					['is_directional'] = true
				},
				{
					['frames'] = 1,
					['start_row'] = 0,
					['start_column'] = 1,
					['delay'] = 0.1,
					['speed'] = 1,
					['mode'] = 1,
					['is_directional'] = true
				},
				{
					['frames'] = 1,
					['start_row'] = 0,
					['start_column'] = 3,
					['delay'] = 0.1,
					['speed'] = 1,
					['mode'] = 1,
					['is_directional'] = true
				},
				{
					['frames'] = 1,
					['start_row'] = 0,
					['start_column'] = 0,
					['delay'] = 0.1,
					['speed'] = 1,
					['mode'] = 1,
					['is_directional'] = false
				}
			}
		},
		{ -- running
			['poses'] = 3,
			['pose_info'] = {
				{
					['frames'] = 10,
					['start_row'] = 0,
					['start_column'] = 4,
					['delay'] = 0.041667,--0.05,
					['speed'] = 1,
					['mode'] = 1,
					['is_directional'] = true
				},
				{
					['frames'] = 10,
					['start_row'] = 2,
					['start_column'] = 4,
					['delay'] = 0.041667,--0.05,
					['speed'] = 1,
					['mode'] = 1,
					['is_directional'] = true
				},
				{
					['frames'] = 10,
					['start_row'] = 4,
					['start_column'] = 4,
					['delay'] = 0.041667,--0.05,
					['speed'] = 1,
					['mode'] = 1,
					['is_directional'] = true
				}
			}
		},
		{ -- jumping
			['poses'] = 3,
			['pose_info'] = {
				{
					['frames'] = 3,
					['start_row'] = 2,
					['start_column'] = 1,
					['delay'] = 0.041667,
					['speed'] = 1,
					['mode'] = 2,
					['is_directional'] = true
				},
				{
					['frames'] = 3,
					['start_row'] = 2,
					['start_column'] = 1,
					['delay'] = 0.041667,
					['speed'] = 1,
					['mode'] = 2,
					['is_directional'] = true
				},
				{
					['frames'] = 3,
					['start_row'] = 4,
					['start_column'] = 1,
					['delay'] = 0.041667,
					['speed'] = 1,
					['mode'] = 2,
					['is_directional'] = true
				}
			}
		},
		{ -- roll jumping
			['poses'] = 3,
			['pose_info'] = {
				{
					['frames'] = 8,
					['start_row'] = 6,
					['start_column'] = 6,
					['delay'] = 0.041667,
					['speed'] = 1,
					['mode'] = 1,
					['is_directional'] = true
				},
				{
					['frames'] = 8,
					['start_row'] = 6,
					['start_column'] = 6,
					['delay'] = 0.041667,
					['speed'] = 1,
					['mode'] = 1,
					['is_directional'] = true
				},
				{
					['frames'] = 8,
					['start_row'] = 6,
					['start_column'] = 6,
					['delay'] = 0.041667,
					['speed'] = 1,
					['mode'] = 1,
					['is_directional'] = true
				}
			}
		}
	}
}

return sprite_state_info