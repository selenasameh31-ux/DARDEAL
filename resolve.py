import sys

strategies = {
    'lib/core/database/api/api_consumer.dart': 'head', # Will manually fix
    'lib/core/database/api/dio_consumer.dart': 'head', # Will manually fix
    'lib/core/database/api/end_points.dart': 'head', # Will manually fix
    'lib/core/database/cache/cache_helper.dart': 'head',
    'lib/core/root/injection_container.dart': 'head', # Will manually fix
    'lib/core/routing/app_routes.dart': 'head',
    'lib/core/routing/routes_export.dart': 'head',
    'lib/core/session/cubit/session_cubit.dart': 'head',
    'lib/main.dart': 'head',
    'pubspec.yaml': 'head',
    'lib/features/auth(Sin+Sup+Fpass)/data/repositories/user_repository_impl.dart': 'origin',
    'lib/features/auth(Sin+Sup+Fpass)/presentation/screens/sign_up_screen.dart': 'head',
    'lib/features/edit_profile/presentation/screens/edit_profile_screen.dart': 'head',
    'lib/core/widgets/navigation_bar.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/data/datasources/wishlist_remote_data_source.dart': 'origin',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/data/models/wishlist_item_model.dart': 'origin',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/data/repositories/wishlist_repository_impl.dart': 'origin',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/domain/repositories/wishlist_repository.dart': 'origin',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/presentation/widgets/favourite_property_card.dart': 'origin',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/models/home_property_model.dart': 'origin',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/models/property_details_model.dart': 'origin',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/models/review_model.dart': 'origin',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/home_screen.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_details_rent.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_details_sale.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_details_wrapper.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_room.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_sharedRoom.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_shortterm.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_type_listing_screen.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/state_management(bloc)/property_type_listing_cubit.dart': 'origin',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/widgets/shared_property_widgets.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/presentation/screens/profile_screen.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/presentation/widgets/profile_header.dart': 'head',
    'lib/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/presentation/screens/favourite_screen.dart': 'origin',
}

def resolve_file(filepath, strategy):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except Exception as e:
        print(f'Error reading {filepath}: {e}')
        return

    output = []
    state = 'normal'
    head_content = []
    origin_content = []

    for line in lines:
        if line.startswith('<<<<<<< ours'):
            state = 'head'
            head_content = []
            origin_content = []
        elif line.startswith('|||||||'):
            state = 'ancestor'
        elif line.startswith('======='):
            state = 'origin'
        elif line.startswith('>>>>>>>'):
            state = 'normal'
            if strategy == 'head':
                output.extend(head_content)
            elif strategy == 'origin':
                output.extend(origin_content)
            elif strategy == 'both':
                output.extend(head_content)
                output.extend(origin_content)
        else:
            if state == 'head':
                head_content.append(line)
            elif state == 'origin':
                origin_content.append(line)
            elif state == 'ancestor':
                pass # ignore ancestor
            else:
                output.append(line)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(output)
    print(f'Resolved {filepath} with strategy {strategy}')

for p, s in strategies.items():
    resolve_file(p, s)
